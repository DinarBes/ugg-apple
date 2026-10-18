//
//  StoresMap.swift
//  ugg-kit
//

import MapKit
import SwiftUI

import UggKitCore

/// Apple Maps with a round brand marker per store (the Android app draws the same ones on Yandex
/// MapKit). A tap on a marker reports the store; the selected one is bigger and dark, and the map
/// glides to it. `MKMapView` rather than SwiftUI `Map`, whose marker API needs iOS 17.
struct StoresMap: UIViewRepresentable {
    let stores: [Store]
    let selectedStoreId: String?
    let onStoreTap: (String) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onStoreTap: onStoreTap)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsCompass = false
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: Coordinator.reuseId)
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        let coordinator = context.coordinator
        coordinator.onStoreTap = onStoreTap

        // Markers and framing only when the set of stores changes (first load, city filter).
        if coordinator.storeIds != stores.map(\.id) {
            coordinator.storeIds = stores.map(\.id)
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(stores.map(StoreAnnotation.init(store:)))
            coordinator.selectedStoreId = selectedStoreId
            frame(mapView, animated: coordinator.hasFramed)
            coordinator.hasFramed = true
            coordinator.refreshMarkers(on: mapView)
            return
        }

        if coordinator.selectedStoreId != selectedStoreId {
            coordinator.selectedStoreId = selectedStoreId
            coordinator.refreshMarkers(on: mapView)

            if let store = stores.first(where: { $0.id == selectedStoreId }) {
                let center = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
            }
        }
    }

    private func frame(_ mapView: MKMapView, animated: Bool) {
        guard !stores.isEmpty else { return }

        if stores.count == 1, let store = stores.first {
            let center = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
            mapView.setRegion(MKCoordinateRegion(center: center, latitudinalMeters: 2_000, longitudinalMeters: 2_000), animated: animated)
        } else {
            mapView.showAnnotations(mapView.annotations, animated: animated)
        }
    }

    // MARK: - Coordinator

    @MainActor
    final class Coordinator: NSObject, MKMapViewDelegate {
        static let reuseId = "store"

        var onStoreTap: (String) -> Void
        var storeIds: [String] = []
        var selectedStoreId: String?
        var hasFramed = false

        init(onStoreTap: @escaping (String) -> Void) {
            self.onStoreTap = onStoreTap
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? StoreAnnotation else { return nil }

            let view = mapView.dequeueReusableAnnotationView(withIdentifier: Self.reuseId, for: annotation)
            style(view, isSelected: annotation.storeId == selectedStoreId)
            view.accessibilityLabel = annotation.title
            return view
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? StoreAnnotation else { return }

            // Our own selection is the state's; the map's is cleared so the same marker taps again.
            mapView.deselectAnnotation(annotation, animated: false)
            onStoreTap(annotation.storeId)
        }

        func refreshMarkers(on mapView: MKMapView) {
            for case let annotation as StoreAnnotation in mapView.annotations {
                guard let view = mapView.view(for: annotation) else { continue }
                style(view, isSelected: annotation.storeId == selectedStoreId)
            }
        }

        private func style(_ view: MKAnnotationView, isSelected: Bool) {
            view.image = isSelected ? Self.selectedMarker : Self.marker
            view.displayPriority = .required
            view.zPriority = isSelected ? .max : .defaultUnselected
        }

        private static let marker = markerImage(size: 30, fill: UIColor(UggColors.accent))
        private static let selectedMarker = markerImage(size: 38, fill: UIColor(UggColors.surfaceInverse))

        /// Round marker in brand colors: a white ring, the fill and a white dot.
        private static func markerImage(size: CGFloat, fill: UIColor) -> UIImage {
            UIGraphicsImageRenderer(size: CGSize(width: size, height: size)).image { context in
                let bounds = CGRect(x: 0, y: 0, width: size, height: size)
                let ring: CGFloat = 3
                UIColor(UggColors.surfaceElevated).setFill()
                context.cgContext.fillEllipse(in: bounds)
                fill.setFill()
                context.cgContext.fillEllipse(in: bounds.insetBy(dx: ring, dy: ring))
                UIColor(UggColors.surfaceElevated).setFill()
                context.cgContext.fillEllipse(in: bounds.insetBy(dx: size * 3 / 8, dy: size * 3 / 8))
            }
        }
    }
}

final class StoreAnnotation: NSObject, MKAnnotation {
    let storeId: String
    let coordinate: CLLocationCoordinate2D
    let title: String?

    init(store: Store) {
        storeId = store.id
        coordinate = CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)
        title = store.name
    }
}

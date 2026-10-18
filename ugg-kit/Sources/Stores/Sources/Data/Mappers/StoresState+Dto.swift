//
//  StoresState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension StoresState {
    init(from dto: UggShared.StoresState) {
        self.init(
            stores: dto.visibleStores.map(Store.init(from:)),
            cities: dto.cities,
            totalCount: dto.stores.count,
            city: dto.city,
            selectedStoreId: dto.selectedStoreId,
            isLoading: dto.isLoading,
            isRefreshing: dto.isRefreshing,
            error: dto.error?.message
        )
    }
}

extension Store {
    init(from dto: UggShared.Store) {
        self.init(
            id: dto.id,
            city: dto.city,
            name: dto.name,
            address: dto.address,
            hours: dto.hours,
            status: dto.status,
            isOpen: dto.isOpen,
            services: dto.services,
            latitude: dto.latitude,
            longitude: dto.longitude,
            phoneUri: dto.phoneUri,
            routeUri: dto.routeUri
        )
    }
}

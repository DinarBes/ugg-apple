//
//  ProductState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension ProductState {
    init(from dto: UggShared.ProductState) {
        self.init(
            product: dto.product.map(Product.init(from:)),
            selection: Selection(
                shadeId: dto.selection.shadeId,
                heightId: dto.selection.heightId,
                size: dto.selection.size,
                isComplete: dto.selection.isComplete
            ),
            expandedDetail: dto.expandedDetail?.intValue,
            isLoading: dto.isLoading,
            isRefreshing: dto.isRefreshing,
            error: dto.error?.message
        )
    }
}

extension Product {
    init(from dto: UggShared.Product) {
        self.init(
            id: dto.id,
            kicker: dto.kicker,
            title: dto.title,
            price: dto.price,
            leadTime: dto.leadTime,
            description: dto.description_,
            photoCount: Int(dto.photoCount),
            shades: dto.shades.map { Shade(id: $0.id, name: $0.name, color: UInt64(bitPattern: $0.color) & 0xFFFFFF) },
            heights: dto.heights.map { Height(id: $0.id, name: $0.name, value: $0.value) },
            sizes: dto.sizes.map { Size(label: $0.label, isAvailable: $0.isAvailable) },
            customSizeHint: dto.customSizeHint,
            features: dto.features.map { Feature(kind: Feature.Kind(from: $0.kind), title: $0.title, caption: $0.caption) },
            details: dto.details.map { Detail(title: $0.title, body: $0.body) }
        )
    }
}

extension Product.Feature.Kind {
    init(from dto: UggShared.ProductFeature.Kind) {
        self = switch dto {
            case .material: .material
            case .handmade: .handmade
            case .warmth: .warmth
            case .warranty: .warranty
        }
    }
}

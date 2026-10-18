//
//  AddressesState+Dto.swift
//  ugg-kit
//

import Foundation
import UggShared

extension Address {
    init(from dto: UggShared.Address) {
        self.init(id: dto.id, summary: dto.summary, comment: dto.comment, isDefault: dto.isDefault)
    }
}

extension AddressesState {
    init(from dto: UggShared.AddressesState) {
        self.init(
            addresses: dto.addresses.map(Address.init(from:)),
            isLoading: dto.isLoading,
            isRefreshing: dto.isRefreshing,
            error: dto.error?.message
        )
    }
}

extension AddressFormState {
    init(from dto: UggShared.AddressFormState) {
        self.init(
            city: dto.address.city,
            street: dto.address.street,
            flat: dto.address.flat,
            comment: dto.address.comment,
            isDefault: dto.address.isDefault,
            isExisting: dto.isExisting,
            cityError: dto.cityError,
            streetError: dto.streetError,
            isLoading: dto.isLoading,
            isSaving: dto.isSaving,
            error: dto.error?.message
        )
    }
}

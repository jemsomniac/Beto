//
//  Products.swift
//  Beto
//
//  Created by Vince Boogie on 9/20/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

public struct Products {
    fileprivate static let Prefix = "com.redgarage.Beto."
    public static let RemoveAds = Prefix + "RemoveAds"
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Products.RemoveAds]
    public static let store = IAPHelper(productIds: Products.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

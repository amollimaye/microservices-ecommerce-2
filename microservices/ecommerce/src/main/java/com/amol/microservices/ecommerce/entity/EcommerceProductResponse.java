package com.amol.microservices.ecommerce.entity;

import java.util.List;

/**
 * @author Amol Limaye
 **/
public class EcommerceProductResponse {
    private List<EcommerceProduct> ecommerceProducts;

    public EcommerceProductResponse(List<EcommerceProduct> ecommerceProducts){
        this.ecommerceProducts = ecommerceProducts;
    }

    public List<EcommerceProduct> getEcommerceProducts() {
        return ecommerceProducts;
    }

    public void setEcommerceProducts(List<EcommerceProduct> ecommerceProducts) {
        this.ecommerceProducts = ecommerceProducts;
    }
}

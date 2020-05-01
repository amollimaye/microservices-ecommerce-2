package com.amol.microservices.ecommerce.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * @author Amol Limaye
 **/
@JsonIgnoreProperties(ignoreUnknown = true)
public class EcommerceProduct {

    Product product;

    String image;

    public EcommerceProduct(Product product){
        this.product = product;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

}

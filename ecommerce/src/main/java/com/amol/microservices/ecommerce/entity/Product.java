package com.amol.microservices.ecommerce.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * @author Amol Limaye
 **/
@JsonIgnoreProperties(ignoreUnknown = true)
public class Product {

    private Long id;

    private int productId;

    private String name;

    private String description;

    private double price;

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}

package com.amol.microservices.ecommerce.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * @author Amol Limaye
 **/
@Component
public class ExternalConfig {

    @Value("${useImages:true}")
    private String useImages;

    @Value("${services.product.base-url:http://product-service:8090}")
    private String productServiceBaseUrl;

    @Value("${services.images.base-url:http://images-service:8090}")
    private String imagesServiceBaseUrl;

    public boolean getUseImages() {
        return Boolean.parseBoolean(useImages);
    }

    public void setUseImages(String useImages) {
        this.useImages = useImages;
    }

    public String getProductServiceBaseUrl() {
        return productServiceBaseUrl;
    }

    public String getImagesServiceBaseUrl() {
        return imagesServiceBaseUrl;
    }
}

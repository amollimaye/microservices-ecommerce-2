package com.amol.microservices.ecommerce.assembler;

import com.amol.microservices.ecommerce.config.ExternalConfig;
import com.amol.microservices.ecommerce.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Amol Limaye
 **/
@Component
public class ProductAssembler {

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private ExternalConfig externalConfig;

    private static final String PRODUCT_SERVICE_ENDPOINT = "/product-service/products";

    private static final String IMAGE_SERVICE_ENDPOINT = "/image-service/images";

    public List<EcommerceProduct> getEcommerceProducts(){
        ResponseEntity<ProductResponse> productResponse = restTemplate.exchange(
                getServiceURL(externalConfig.getProductServiceBaseUrl(), PRODUCT_SERVICE_ENDPOINT),
                HttpMethod.GET,null,ProductResponse.class);
        ResponseEntity<ImageResponse> imageResponse = null;
        if(externalConfig.getUseImages()) {
            imageResponse = restTemplate.exchange(getServiceURL(externalConfig.getImagesServiceBaseUrl(), IMAGE_SERVICE_ENDPOINT),
                    HttpMethod.GET, null, ImageResponse.class);
        }
        return mergeProductData(productResponse,imageResponse);
    }

    private String getServiceURL(String serviceBaseUrl, String serviceEndpoint){
        return new StringBuilder(serviceBaseUrl)
                .append(serviceEndpoint).toString();
    }

    private List<EcommerceProduct> mergeProductData(ResponseEntity<ProductResponse> productResponse, ResponseEntity<ImageResponse> imageResponse){
        List<EcommerceProduct> ecommerceProducts = new ArrayList<>();
        for(Product product:productResponse.getBody().getProducts()){
            EcommerceProduct ecommerceProduct = new EcommerceProduct(product);
            if(imageResponse!=null) {
                Image image = imageResponse.getBody().getImages().
                        stream().filter(i -> product.getProductId() == i.getProductId())
                        .findAny().orElse(null);
                ecommerceProduct.setImage(image.getPath());
            }
            ecommerceProducts.add(ecommerceProduct);
        }
        return ecommerceProducts;
    }
}

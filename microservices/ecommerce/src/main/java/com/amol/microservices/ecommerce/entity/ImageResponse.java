package com.amol.microservices.ecommerce.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.util.List;

/**
 * @author Amol Limaye
 **/
@JsonIgnoreProperties(ignoreUnknown = true)
public class ImageResponse{
    private List<Image> images;

    public ImageResponse(){
    }

    public ImageResponse(List<Image> images){
        this.images = images;
    }

    public List<Image> getImages() {
        return images;
    }

    public void setImages(List<Image> images) {
        this.images = images;
    }
}

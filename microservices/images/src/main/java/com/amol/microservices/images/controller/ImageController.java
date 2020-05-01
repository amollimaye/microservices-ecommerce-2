package com.amol.microservices.images.controller;

import com.amol.microservices.images.entity.ImageResponse;
import com.amol.microservices.images.repository.ImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author Amol Limaye
 **/
@RestController
public class ImageController {

    @Autowired
    private ImageRepository imageRepository;

    @GetMapping("/images")
    public ImageResponse getAllImages(){
        return new ImageResponse(imageRepository.findAll());
    }
}

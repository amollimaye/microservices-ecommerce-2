package com.amol.microservices.images.repository;

import com.amol.microservices.images.entity.Image;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

/**
 * @author Amol Limaye
 **/
public interface ImageRepository extends CrudRepository<Image,Long>{

    List<Image> findAll();
}

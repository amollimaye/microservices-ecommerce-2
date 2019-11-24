package com.amol.microservices.product.repository;

import com.amol.microservices.product.entity.Product;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface ProductRepository extends CrudRepository<Product,Long> {

    List<Product> findAll();
}

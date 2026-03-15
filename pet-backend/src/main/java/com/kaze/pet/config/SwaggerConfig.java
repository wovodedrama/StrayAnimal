package com.kaze.pet.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
@Configuration
public class SwaggerConfig {

    @Bean
    public GroupedOpenApi publicApi() {
        return GroupedOpenApi.builder()
            .group("default")
            .packagesToScan("com.kaze.springboot.controller")
            .pathsToMatch("/**")
            .build();
    }

    @Bean
    public OpenAPI springShopOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("接口文档")
                .description("Restful 接口")
                .contact(new Contact().name("xxx").url("#").email("xxx@qq.com"))
                .version("1.0"));
    }
}

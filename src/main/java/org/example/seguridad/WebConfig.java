
package org.example.seguridad;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final AutorizacionInterceptor autorizacionInterceptor;
    private final MenuClienteInterceptor menuClienteInterceptor;

    public WebConfig(
            AutorizacionInterceptor autorizacionInterceptor,
            MenuClienteInterceptor menuClienteInterceptor) {

        this.autorizacionInterceptor = autorizacionInterceptor;
        this.menuClienteInterceptor = menuClienteInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(autorizacionInterceptor)
                .addPathPatterns(

                        "/productos",
                        "/productos/**",

                        "/categorias",
                        "/categorias/**",

                        "/admin",
                        "/admin/**"
                );

        registry.addInterceptor(menuClienteInterceptor)
                .addPathPatterns(
                        "/catalogo",
                        "/catalogo/**",
                        "/publicidad",
                        "/publicidad/**",
                        "/contacto",
                        "/contacto/**",
                        "/carrito",
                        "/carrito/**"
                );
    }
}

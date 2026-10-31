package org.example.publicidad;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PublicidadController {

    @GetMapping("/publicidad")
    public String mostrarPublicidad() {
        return "publicidad/promociones";
    }
}

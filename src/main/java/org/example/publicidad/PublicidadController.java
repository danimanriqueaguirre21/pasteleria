
package org.example.publicidad;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PublicidadController {

    private final PromocionService promocionService;

    public PublicidadController(PromocionService promocionService) {
        this.promocionService = promocionService;
    }

    @GetMapping("/publicidad")
    public String mostrarPublicidad(Model model) {
        model.addAttribute(
                "promociones",
                promocionService.listarPromocionesActivas()
        );

        return "publicidad/publicidad";
    }
}

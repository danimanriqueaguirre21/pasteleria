package org.example.publicidad;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/promociones")
public class AdminPromocionController {

    private final PromocionService promocionService;

    public AdminPromocionController(PromocionService promocionService) {
        this.promocionService = promocionService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("promociones", promocionService.listarPromociones());
        return "admin/promociones";
    }

    @GetMapping("/nuevo")
    public String mostrarFormulario(Model model) {
        model.addAttribute("promocion", new Promocion());
        return "admin/promocion";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Promocion promocion) {
        if (promocion.getIdPromocion() == null) {
            promocionService.crearPromocion(promocion);
        } else {
            promocionService.actualizarPromocion(promocion);
        }

        return "redirect:/admin/promociones";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable int id, Model model) {
        Promocion promocion = promocionService.obtenerPromocionPorId(id);

        if (promocion == null) {
            return "redirect:/admin/promociones";
        }

        model.addAttribute("promocion", promocion);
        return "admin/promocion";
    }

    @PostMapping("/desactivar/{id}")
    public String desactivar(@PathVariable int id) {
        promocionService.desactivarPromocion(id);
        return "redirect:/admin/promociones";
    }
}

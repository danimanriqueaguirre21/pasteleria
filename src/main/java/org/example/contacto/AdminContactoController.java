package org.example.contacto;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/mensajes")
public class AdminContactoController {

    private final ContactoService contactoService;

    public AdminContactoController(ContactoService contactoService) {
        this.contactoService = contactoService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("mensajes", contactoService.listarMensajes());
        return "admin/mensajes";
    }
}

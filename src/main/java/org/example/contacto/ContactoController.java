
package org.example.contacto;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ContactoController {

    private final ContactoService contactoService;

    public ContactoController(ContactoService contactoService) {
        this.contactoService = contactoService;
    }

    @GetMapping("/contacto")
    public String mostrarContacto() {
        return "contacto/contacto";
    }

    @PostMapping("/contacto/enviar")
    public String enviarMensaje(
            @RequestParam String nombre,
            @RequestParam String correo,
            @RequestParam String asunto,
            @RequestParam String mensaje,
            Model model) {

        try {
            contactoService.guardarMensaje(
                    nombre, correo, asunto, mensaje
            );

            model.addAttribute(
                    "exito",
                    "Tu mensaje fue enviado correctamente."
            );

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
        }

        return "contacto/contacto";
    }
}

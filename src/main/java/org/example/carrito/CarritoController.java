
package org.example.carrito;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/carrito")
public class CarritoController {

    private final CarritoService carritoService;

    public CarritoController(CarritoService carritoService) {
        this.carritoService = carritoService;
    }

    @SuppressWarnings("unchecked")
    private List<ItemCarrito> obtenerCarrito(HttpSession session) {
        List<ItemCarrito> carrito =
                (List<ItemCarrito>) session.getAttribute("carrito");

        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }

        return carrito;
    }

    @GetMapping
    public String mostrarCarrito(Model model, HttpSession session) {
        List<ItemCarrito> carrito = obtenerCarrito(session);

        model.addAttribute("carrito", carrito);
        model.addAttribute("total", carritoService.calcularTotal(carrito));

        return "carrito/carrito";
    }

    @PostMapping("/agregar")
    public String agregarProducto(
            @RequestParam int idProducto,
            @RequestParam(defaultValue = "1") int cantidad,
            HttpSession session,
            Model model) {

        try {
            carritoService.agregarProducto(
                    obtenerCarrito(session), idProducto, cantidad
            );
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return mostrarCarrito(model, session);
        }

        return "redirect:/carrito";
    }

    @PostMapping("/actualizar")
    public String actualizarCantidad(
            @RequestParam int idProducto,
            @RequestParam int cantidad,
            HttpSession session,
            Model model) {

        try {
            carritoService.actualizarCantidad(
                    obtenerCarrito(session), idProducto, cantidad
            );
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return mostrarCarrito(model, session);
        }

        return "redirect:/carrito";
    }

    @PostMapping("/eliminar")
    public String eliminarProducto(
            @RequestParam int idProducto,
            HttpSession session) {

        carritoService.eliminarProducto(
                obtenerCarrito(session), idProducto
        );

        return "redirect:/carrito";
    }
}

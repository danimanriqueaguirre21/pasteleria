
package org.example.producto;

import org.example.categoria.CategoriaService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/productos")
public class ProductoController {

    private final ProductoService productoService;
    private final CategoriaService categoriaService;

    public ProductoController(ProductoService productoService,
                              CategoriaService categoriaService) {
        this.productoService = productoService;
        this.categoriaService = categoriaService;
    }

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("productos", productoService.listarProductos());
        model.addAttribute("nombresCategorias", categoriaService.nombresPorId());

        return "producto/lista";
    }

    @GetMapping("/nuevo")
    public String mostrarFormulario(Model model) {
        model.addAttribute("producto", new Producto());
        model.addAttribute("categorias",
                categoriaService.listarCategorias());

        return "producto/formulario";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Producto producto, Model model) {

        try {
            if (producto.getIdProducto() == null) {
                productoService.crearProducto(producto);
            } else {
                productoService.actualizarProducto(producto);
            }
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("producto", producto);
            model.addAttribute("categorias",
                    categoriaService.listarCategorias());
            return "producto/formulario";
        }

        return "redirect:/productos";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable int id, Model model) {

        Producto producto = productoService.obtenerProductoPorId(id);

        if (producto == null) {
            return "redirect:/productos";
        }

        model.addAttribute("producto", producto);
        model.addAttribute("categorias",
                categoriaService.listarCategorias());

        return "producto/formulario";
    }

    @PostMapping("/desactivar/{id}")
    public String desactivar(@PathVariable int id) {
        productoService.desactivarProducto(id);
        return "redirect:/productos";
    }
}

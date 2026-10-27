
package org.example.categoria;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/categorias")
public class CategoriaController {

    private final CategoriaService categoriaService;

    public CategoriaController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }

    @GetMapping
    public String listar(Model model) {

        model.addAttribute(
                "categorias",
                categoriaService.listarCategorias()
        );

        return "categoria/lista";
    }

    @GetMapping("/nuevo")
    public String mostrarFormulario(Model model) {

        model.addAttribute("categoria", new Categoria());

        return "categoria/categoria";
    }

    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Categoria categoria, Model model) {

        try {
            if (categoria.getIdCategoria() == null) {
                categoriaService.crearCategoria(categoria);
            } else {
                categoriaService.actualizarCategoria(categoria);
            }
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("categoria", categoria);
            return "categoria/categoria";
        }

        return "redirect:/categorias";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable int id, Model model) {

        Categoria categoria =
                categoriaService.obtenerCategoriaPorId(id);

        if (categoria == null) {
            return "redirect:/categorias";
        }

        model.addAttribute("categoria", categoria);

        return "categoria/categoria";
    }

    @PostMapping("/desactivar/{id}")
    public String desactivar(@PathVariable int id) {

        categoriaService.desactivarCategoria(id);

        return "redirect:/categorias";
    }
}

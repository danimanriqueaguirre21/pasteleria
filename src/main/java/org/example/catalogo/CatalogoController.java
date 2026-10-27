package org.example.catalogo;

import org.example.categoria.CategoriaService;
import org.example.producto.ProductoService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CatalogoController {

    private final ProductoService productoService;
    private final CategoriaService categoriaService;

    public CatalogoController(
            ProductoService productoService,
            CategoriaService categoriaService) {

        this.productoService = productoService;
        this.categoriaService = categoriaService;
    }

    @GetMapping("/catalogo")
    public String mostrarCatalogo(
            Model model,
            @RequestParam(defaultValue = "") String buscar,
            @RequestParam(required = false) Integer categoria,
            @RequestParam(defaultValue = "false") boolean disponibles) {

        model.addAttribute(
                "productos",
                productoService.listarParaCatalogo(buscar, categoria, disponibles)
        );
        model.addAttribute("categorias", categoriaService.listarCategorias());
        model.addAttribute("buscar", buscar);
        model.addAttribute("idCategoriaSeleccionada", categoria);
        model.addAttribute("disponibles", disponibles);

        return "catalogo/catalogo";
    }
}

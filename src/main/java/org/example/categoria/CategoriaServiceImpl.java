
package org.example.categoria;

import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class CategoriaServiceImpl implements CategoriaService {

    private final CategoriaDAO categoriaDAO;

    public CategoriaServiceImpl(CategoriaDAO categoriaDAO) {
        this.categoriaDAO = categoriaDAO;
    }

    @Override
    public List<Categoria> listarCategorias() {
        return categoriaDAO.listarCategorias();
    }

    @Override
    public Map<Integer, String> nombresPorId() {
        Map<Integer, String> nombres = new HashMap<>();

        for (Categoria categoria : categoriaDAO.listarCategorias()) {
            nombres.put(categoria.getIdCategoria(), categoria.getNombre());
        }

        return nombres;
    }

    @Override
    public Categoria obtenerCategoriaPorId(int id) {
        return categoriaDAO.obtenerCategoriaPorId(id);
    }

    @Override
    public void crearCategoria(Categoria categoria) {
        prepararNombre(categoria);
        categoriaDAO.crearCategoria(categoria);
    }

    @Override
    public void actualizarCategoria(Categoria categoria) {
        prepararNombre(categoria);
        categoriaDAO.actualizarCategoria(categoria);
    }

    private void prepararNombre(Categoria categoria) {
        String nombre = categoria.getNombre() == null
                ? ""
                : categoria.getNombre().trim();

        if (nombre.isEmpty()) {
            throw new IllegalArgumentException(
                    "El nombre de la categoría es obligatorio"
            );
        }

        for (Categoria existente : categoriaDAO.listarCategorias()) {
            boolean mismoNombre = existente.getNombre() != null
                    && existente.getNombre().trim().equalsIgnoreCase(nombre);
            boolean esOtra = !Objects.equals(
                    existente.getIdCategoria(),
                    categoria.getIdCategoria()
            );

            if (mismoNombre && esOtra) {
                throw new IllegalArgumentException(
                        "Ya existe una categoría con ese nombre"
                );
            }
        }

        categoria.setNombre(nombre);
    }

    @Override
    public void desactivarCategoria(int id) {
        categoriaDAO.desactivarCategoria(id);
    }
}

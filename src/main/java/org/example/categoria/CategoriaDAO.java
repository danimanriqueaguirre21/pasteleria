
package org.example.categoria;

import java.util.List;

public interface CategoriaDAO {

    List<Categoria> listarCategorias();

    Categoria obtenerCategoriaPorId(int id);

    void crearCategoria(Categoria categoria);

    void actualizarCategoria(Categoria categoria);

    void desactivarCategoria(int id);
}

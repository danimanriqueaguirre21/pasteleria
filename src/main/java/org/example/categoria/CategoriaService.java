
package org.example.categoria;

import java.util.List;
import java.util.Map;

public interface CategoriaService {

    List<Categoria> listarCategorias();

    Map<Integer, String> nombresPorId();

    Categoria obtenerCategoriaPorId(int id);

    void crearCategoria(Categoria categoria);

    void actualizarCategoria(Categoria categoria);

    void desactivarCategoria(int id);
}

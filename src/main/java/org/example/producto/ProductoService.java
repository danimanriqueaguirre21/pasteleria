
package org.example.producto;

import java.util.List;

public interface ProductoService {

    List<Producto> listarProductos();

    List<Producto> listarProductosActivos();

    List<Producto> listarParaCatalogo(String buscar, Integer idCategoria, boolean soloDisponibles);

    Producto obtenerProductoPorId(int id);

    void crearProducto(Producto producto);

    void actualizarProducto(Producto producto);

    void desactivarProducto(int id);
}

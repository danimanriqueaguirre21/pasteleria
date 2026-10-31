
package org.example.producto;

import java.util.List;

public interface ProductoService {

    List<Producto> listarProductos();

    List<Producto> listarProductosActivos();

    List<Producto> listarParaCatalogo(String buscar, Integer idCategoria, boolean soloDisponibles);

    Producto obtenerProductoPorId(int id);

    Producto obtenerProductoParaPedido(int id);

    boolean descontarStock(int idProducto, int cantidad);

    int aumentarStock(int idProducto, int cantidad);

    void crearProducto(Producto producto);

    void actualizarProducto(Producto producto);

    void desactivarProducto(int id);
}

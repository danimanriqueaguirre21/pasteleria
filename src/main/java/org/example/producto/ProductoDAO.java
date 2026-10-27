
package org.example.producto;

import java.util.List;

public interface ProductoDAO {

    List<Producto> listarProductos();

    List<Producto> listarProductosActivos();

    Producto obtenerProductoPorId(int id);

    void crearProducto(Producto producto);

    void actualizarProducto(Producto producto);

    void desactivarProducto(int id);

    Producto obtenerProductoParaPedido(int id);

    boolean descontarStock(int idProducto, int cantidad);

    int aumentarStock(int idProducto, int cantidad);

}

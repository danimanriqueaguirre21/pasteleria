
package org.example.carrito;

import java.math.BigDecimal;
import java.util.List;

public interface CarritoService {

    void agregarProducto(List<ItemCarrito> carrito, int idProducto, int cantidad);

    void actualizarCantidad(List<ItemCarrito> carrito, int idProducto, int cantidad);

    void eliminarProducto(List<ItemCarrito> carrito, int idProducto);

    BigDecimal calcularTotal(List<ItemCarrito> carrito);
}

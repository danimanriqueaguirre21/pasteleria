
package org.example.carrito;

import org.example.producto.Producto;
import org.example.producto.ProductoService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class CarritoServiceImpl implements CarritoService {

    private final ProductoService productoService;

    public CarritoServiceImpl(ProductoService productoService) {
        this.productoService = productoService;
    }

    @Override
    public void agregarProducto(List<ItemCarrito> carrito, int idProducto, int cantidad) {
        validarCantidad(cantidad);
        Producto producto = productoActivo(idProducto);

        ItemCarrito itemExistente = null;

        for (ItemCarrito item : carrito) {
            if (item.getProducto().getIdProducto() == idProducto) {
                itemExistente = item;
                break;
            }
        }

        int cantidadActual = itemExistente == null ? 0 : itemExistente.getCantidad();

        if (cantidad > producto.getStock() - cantidadActual) {
            throw new IllegalArgumentException("No hay suficiente stock disponible");
        }

        if (itemExistente != null) {
            itemExistente.setProducto(producto);
            itemExistente.setCantidad(cantidadActual + cantidad);
        } else {
            carrito.add(new ItemCarrito(producto, cantidad));
        }
    }

    @Override
    public void actualizarCantidad(List<ItemCarrito> carrito, int idProducto, int cantidad) {
        validarCantidad(cantidad);
        Producto producto = productoActivo(idProducto);

        if (cantidad > producto.getStock()) {
            throw new IllegalArgumentException("No hay suficiente stock disponible");
        }

        for (ItemCarrito item : carrito) {
            if (item.getProducto().getIdProducto() == idProducto) {
                item.setProducto(producto);
                item.setCantidad(cantidad);
                return;
            }
        }

        throw new IllegalArgumentException("El producto no está en el carrito");
    }

    @Override
    public void eliminarProducto(List<ItemCarrito> carrito, int idProducto) {
        for (int i = carrito.size() - 1; i >= 0; i--) {
            if (carrito.get(i).getProducto().getIdProducto() == idProducto) {
                carrito.remove(i);
            }
        }
    }

    @Override
    public BigDecimal calcularTotal(List<ItemCarrito> carrito) {
        BigDecimal total = BigDecimal.ZERO;

        for (ItemCarrito item : carrito) {
            total = total.add(item.getSubtotal());
        }

        return total;
    }

    private void validarCantidad(int cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad debe ser mayor que cero");
        }
    }

    private Producto productoActivo(int idProducto) {
        Producto producto = productoService.obtenerProductoPorId(idProducto);

        if (producto == null || !producto.isEstado()) {
            throw new IllegalArgumentException("El producto no existe o está inactivo");
        }

        return producto;
    }
}

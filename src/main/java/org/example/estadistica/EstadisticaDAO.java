
package org.example.estadistica;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Map;

public interface EstadisticaDAO {

    Map<LocalDate, BigDecimal> obtenerVentasDiarias();

    Map<LocalDate, Integer> obtenerPedidosPorDia();

    Map<LocalDate, Integer> obtenerEntregasPorDia();

    Map<LocalDate, BigDecimal> obtenerTicketPromedioPorDia();

    Map<LocalDate, Integer> obtenerUnidadesVendidasPorDia();

    BigDecimal obtenerImporteTotal();

    int obtenerTotalPedidos();

    int obtenerTotalEntregados();

    BigDecimal obtenerTicketPromedioGeneral();

    int obtenerTotalUnidades();

}

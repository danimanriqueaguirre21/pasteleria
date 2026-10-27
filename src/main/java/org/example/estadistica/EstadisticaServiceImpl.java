
package org.example.estadistica;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Map;

@Service
public class EstadisticaServiceImpl
        implements EstadisticaService {

    private final EstadisticaDAO estadisticaDAO;

    public EstadisticaServiceImpl(
            EstadisticaDAO estadisticaDAO) {

        this.estadisticaDAO = estadisticaDAO;
    }

    @Override
    public Map<LocalDate, BigDecimal> obtenerVentasDiarias() {

        return estadisticaDAO.obtenerVentasDiarias();
    }

    @Override
    public Map<LocalDate, Integer> obtenerPedidosPorDia() {

        return estadisticaDAO.obtenerPedidosPorDia();
    }

    @Override
    public Map<LocalDate, Integer> obtenerEntregasPorDia() {

        return estadisticaDAO.obtenerEntregasPorDia();
    }

    @Override
    public Map<LocalDate, BigDecimal>
    obtenerTicketPromedioPorDia() {

        return estadisticaDAO.obtenerTicketPromedioPorDia();
    }

    @Override
    public Map<LocalDate, Integer>
    obtenerUnidadesVendidasPorDia() {

        return estadisticaDAO.obtenerUnidadesVendidasPorDia();
    }

    @Override
    public BigDecimal obtenerImporteTotal() {

        return estadisticaDAO.obtenerImporteTotal();
    }

    @Override
    public int obtenerTotalPedidos() {

        return estadisticaDAO.obtenerTotalPedidos();
    }

    @Override
    public int obtenerTotalEntregados() {

        return estadisticaDAO.obtenerTotalEntregados();
    }

    @Override
    public BigDecimal obtenerTicketPromedioGeneral() {

        return estadisticaDAO.obtenerTicketPromedioGeneral();
    }

    @Override
    public int obtenerTotalUnidades() {

        return estadisticaDAO.obtenerTotalUnidades();
    }
}

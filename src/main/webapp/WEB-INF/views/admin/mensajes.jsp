<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mensajes de contacto - Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="categorias-pagina">

<c:set var="tituloAdmin" value="Mensajes de contacto"/>
<c:set var="menuActivo" value="mensajes"/>
<%@ include file="menu.jsp" %>

<main class="contenedor">
    <div class="barra-acciones">
        <div>
            <h2>Mensajes recibidos</h2>
            <p>Aquí aparecen los mensajes que envían desde la página Contacto.</p>
        </div>
    </div>

    <section class="panel">
        <div class="tabla-contenedor">
            <table>
                <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Nombre</th>
                    <th>Correo</th>
                    <th>Asunto</th>
                    <th>Mensaje</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="mensaje" items="${mensajes}">
                    <tr>
                        <td><c:out value="${mensaje.fecha}"/></td>
                        <td class="nombre"><c:out value="${mensaje.nombre}"/></td>
                        <td><c:out value="${mensaje.correo}"/></td>
                        <td><c:out value="${mensaje.asunto}"/></td>
                        <td class="descripcion"><c:out value="${mensaje.mensaje}"/></td>
                    </tr>
                </c:forEach>

                <c:if test="${empty mensajes}">
                    <tr>
                        <td colspan="5" class="sin-registros">
                            Todavía no hay mensajes de contacto.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>
</main>

<footer>
    Mi Pastelería · Sistema de gestión
</footer>
</body>
</html>

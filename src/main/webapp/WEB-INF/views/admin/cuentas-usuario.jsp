<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="pagina-admin-usuarios admin-app">
<c:set var="tituloAdmin" value="Gestión de usuarios"/>
<c:set var="menuActivo" value="usuarios"/>
<%@ include file="menu.jsp" %>
<main class="usuarios-contenedor">
    <div class="encabezado-modulo">
        <div>
            <h2>Usuarios registrados</h2>
            <p>Registra cajeros y repartidores, consulta usuarios y administra sus estados.</p>
        </div>
        <a class="btn-nuevo" href="#registrar-empleado">+ Agregar usuario</a>
    </div>

    <c:if test="${not empty mensaje}">
        <div class="mensaje" role="status"><c:out value="${mensaje}"/></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="error" role="alert"><c:out value="${error}"/></div>
    </c:if>

    <section class="panel panel-lista" id="usuarios-registrados">
        <form class="filtro-rol" method="get" action="${pageContext.request.contextPath}/admin/usuarios#usuarios-registrados">
            <div class="campo">
                <label for="filtro-rol">Buscar por rol</label>
                <select id="filtro-rol" name="rol">
                    <option value="">Todos</option>
                    <option value="ADMINISTRADOR" <c:if test="${rolFiltro eq 'ADMINISTRADOR'}">selected</c:if>>Administrador</option>
                    <option value="CLIENTE" <c:if test="${rolFiltro eq 'CLIENTE'}">selected</c:if>>Cliente</option>
                    <option value="CAJERO" <c:if test="${rolFiltro eq 'CAJERO'}">selected</c:if>>Cajero</option>
                    <option value="REPARTIDOR" <c:if test="${rolFiltro eq 'REPARTIDOR'}">selected</c:if>>Repartidor</option>
                </select>
            </div>
            <button type="submit" class="btn-guardar">Filtrar</button>
            <c:if test="${not empty rolFiltro}">
                <a href="${pageContext.request.contextPath}/admin/usuarios#usuarios-registrados">Ver todos</a>
            </c:if>
        </form>
        <div class="tabla-contenedor">
            <table>
                <thead><tr><th>ID</th><th>Nombre completo</th><th>Correo</th><th>Rol</th><th>Estado</th><th>Acción</th></tr></thead>
                <tbody>
                <c:forEach var="usuario" items="${usuarios}">
                    <tr>
                        <td><c:out value="${usuario.idUsuario}"/></td>
                        <td><c:out value="${usuario.nombres}"/> <c:out value="${usuario.apellidos}"/></td>
                        <td><c:out value="${usuario.correo}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${usuario.rol eq 'ADMINISTRADOR'}">Administrador</c:when>
                                <c:when test="${usuario.rol eq 'CLIENTE'}">Cliente</c:when>
                                <c:when test="${usuario.rol eq 'CAJERO'}">Cajero</c:when>
                                <c:when test="${usuario.rol eq 'REPARTIDOR'}">Repartidor</c:when>
                                <c:otherwise>Desconocido</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${usuario.estado}"><span class="activo">Activo</span></c:when>
                                <c:otherwise><span class="inactivo">Inactivo</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${usuario.rol eq 'ADMINISTRADOR'}"><span class="protegido">Protegido</span></c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/usuarios/estado">
                                        <input type="hidden" name="idUsuario" value="${usuario.idUsuario}">
                                        <input type="hidden" name="estado" value="${not usuario.estado}">
                                        <c:if test="${not empty rolFiltro}">
                                            <input type="hidden" name="rol" value="${rolFiltro}">
                                        </c:if>
                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${usuario.estado}">
                                                <button type="submit" class="btn-desactivar" onclick="return confirm('¿Desactivar esta cuenta?');">Desactivar</button>
                                            </c:when>
                                            <c:otherwise><button type="submit" class="btn-activar">Activar</button></c:otherwise>
                                        </c:choose>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty usuarios}">
                    <tr>
                        <td colspan="6" class="sin-usuarios">
                            <c:choose>
                                <c:when test="${not empty rolFiltro}">No hay usuarios con ese rol.</c:when>
                                <c:otherwise>No hay usuarios registrados.</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>

    <section class="panel" id="registrar-empleado">
        <h2>Registrar nuevo empleado</h2>
        <p class="texto-ayuda">El administrador puede crear cuentas con los roles Cajero o Repartidor.</p>
        <form class="formulario" action="${pageContext.request.contextPath}/admin/usuarios/registrar" method="post">
            <div class="campo">
                <label for="nombres">Nombres</label>
                <input type="text" id="nombres" name="nombres" maxlength="100" autocomplete="given-name" required>
            </div>
            <div class="campo">
                <label for="apellidos">Apellidos</label>
                <input type="text" id="apellidos" name="apellidos" maxlength="100" autocomplete="family-name" required>
            </div>
            <div class="campo">
                <label for="correo">Correo electrónico</label>
                <input type="email" id="correo" name="correo" maxlength="254" autocomplete="email" required>
            </div>
            <div class="campo">
                <label for="contrasena">Contraseña inicial</label>
                <input type="password" id="contrasena" name="contrasena" minlength="8" autocomplete="new-password" required>
            </div>
            <div class="campo">
                <label for="rol">Rol del empleado</label>
                <select id="rol" name="rol" required>
                    <option value="">Seleccione un rol</option>
                    <option value="CAJERO">Cajero</option>
                    <option value="REPARTIDOR">Repartidor</option>
                </select>
            </div>
            <div class="acciones">
                <c:if test="${not empty _csrf}">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                </c:if>
                <button type="submit" class="btn-guardar">Crear cuenta</button>
            </div>
        </form>
    </section>
</main>
<%@ include file="pie.jsp" %>
<script>
    if (location.hash === "#usuarios-registrados") {
        window.addEventListener("load", function () {
            var lista = document.getElementById("usuarios-registrados");

            if (lista) {
                lista.scrollIntoView();
            }
        });
    }
</script>
</body>
</html>

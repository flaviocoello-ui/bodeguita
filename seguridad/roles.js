import { api } from "../login/login.js";

const tbody = document.querySelector("#pane-roles tbody");

const TEXTO_NIVEL = { 1: "Superior", 2: "Operativo", 3: "Restringido" };

function celda(texto) {
  const td = document.createElement("td");
  td.textContent = texto;
  return td;
}

function celdaNivel(nivel) {
  const td = document.createElement("td");
  if (nivel === null || nivel === undefined) {
    return td;
  }
  const contenedor = document.createElement("div");
  contenedor.className = "d-flex flex-column gap-1";

  const badge = document.createElement("span");
  badge.className =
    "badge align-self-start " +
    (nivel === 1 ? "text-bg-primary" : "text-bg-secondary");
  badge.textContent = "Nivel " + nivel;

  const detalle = document.createElement("small");
  detalle.className = "text-muted";
  detalle.textContent = TEXTO_NIVEL[nivel] || "";

  contenedor.append(badge, detalle);
  td.appendChild(contenedor);
  return td;
}

function celdaAcciones(activo) {
  const td = document.createElement("td");
  td.innerHTML =
    '<div class="d-flex gap-1">' +
    '<button class="btn btn-sm btn-outline-primary" title="Editar"><i class="bi bi-pencil"></i></button>' +
    (activo
      ? '<button class="btn btn-sm btn-outline-primary" title="Desactivar"><i class="bi bi-toggle-on"></i></button>'
      : '<button class="btn btn-sm btn-outline-secondary" title="Activar"><i class="bi bi-toggle-off opacity-50"></i></button>') +
    "</div>";
  return td;
}

function filaRol(rol) {
  const activo = rol.estado !== false && rol.estado !== "0";
  const tr = document.createElement("tr");
  if (!activo) {
    tr.classList.add("text-muted");
  }
  tr.append(
    celda(rol.idRol),
    celda(rol.nRol),
    celda(rol.descripcion || ""),
    celdaNivel(rol.nivel),
    celdaAcciones(activo),
  );
  return tr;
}

function filaMensaje(texto) {
  const tr = document.createElement("tr");
  const td = celda(texto);
  td.colSpan = 5;
  td.className = "text-center text-muted";
  tr.appendChild(td);
  return tr;
}

export async function listarRoles() {
  try {
    const roles = (await api("GET", "/api/roles")) || [];
    if (!roles.length) {
      tbody.replaceChildren(filaMensaje("No hay roles registrados."));
      return;
    }
    tbody.replaceChildren(...roles.map(filaRol));
  } catch (err) {
    if (err.status === 401) {
      window.location.href = "../login/login.html";
      return;
    }
    tbody.replaceChildren(filaMensaje(err.mensaje || "No se pudo cargar."));
  }
}

listarRoles();

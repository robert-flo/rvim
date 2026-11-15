---@class rvim.theme.palette
local M = {}

M.light = {
	bg = "#eff1f5", -- Fondo papel reposado anti-fatiga
	bg_alt = "#e6e9ef", -- Superficie secundaria / panels
	bg_subtle = "#ccd0da", -- Selección y estados activos suaves
	bg_highlight = "#dce0e8", -- Separadores y bordes inactivos
	fg = "#3a3d52", -- Texto base carbón pizarra anti-halo
	fg_dim = "#5c5f77", -- Comentarios legibles y texto secundario
	fg_muted = "#8c8fa1", -- Líneas inactivas y placeholders
	fg_bold = "#181926", -- Texto de máxima densidad / énfasis

	-- Tonos Joya de Alto Contraste (SSoT)
	blue = "#1e66f5", -- Azul Real (funciones, cursor, acento activo)
	blue_deep = "#0969da", -- Azul Zafiro (keywords, enlaces, tags)
	green = "#2e7d32", -- Verde Bosque (strings, adiciones diff)
	green_bright = "#15803d", -- Verde vivo (estados de éxito)
	amber = "#b45309", -- Ámbar Tostado (números, constantes, advertencias)
	amber_warm = "#92400e", -- Ámbar Cálido (constantes built-in)
	red = "#d20f39", -- Rojo Rubí (errores, eliminaciones diff)
	red_bright = "#b91c1c", -- Rojo Carmesí (errores críticos)
	violet = "#7c3aed", -- Violeta Malva (tipos, clases, interfaces)
	purple = "#6d28d9", -- Púrpura Profundo (macros, decoradores)
	teal = "#0f766e", -- Teal Pino (operadores, regex, rutas)
	cyan = "#0e7490", -- Teal Océano (propiedades, módulos)

	-- Tintes suaves para diagnósticos (evita texto blanco sobre fondo estridente)
	warn_bg = "#fef3c7",
	error_bg = "#fde8e8",
	info_bg = "#e0f2fe",
	hint_bg = "#e0f7f6",
}

return M

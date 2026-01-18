import Cairo from "gi://cairo";
import type { Gtk } from "ags/gtk4";

type CairoContext = Parameters<Gtk.DrawingAreaDrawFunc>[1];

// Shell dimensions
export const BAR_HEIGHT = 40;
export const EDGE_WIDTH = 16;
const BORDER_RADIUS = 24;

// $base02: #d5c4a1 (Gruvbox)
const BG_COLOR = { r: 0.84, g: 0.77, b: 0.63, a: 1 };

// Shell window reference - set by Shell.tsx
export let shellWindow: Gtk.Window;
export function setShellWindow(win: Gtk.Window) {
  shellWindow = win;
}

function roundedRect(
  ctx: CairoContext,
  x: number,
  y: number,
  w: number,
  h: number,
  r: number,
) {
  r = Math.max(0, Math.min(r, Math.min(w, h) / 2));
  const pi2 = Math.PI / 2;
  ctx.newPath();
  ctx.arc(x + w - r, y + r, r, -pi2, 0);
  ctx.arc(x + w - r, y + h - r, r, 0, pi2);
  ctx.arc(x + r, y + h - r, r, pi2, Math.PI);
  ctx.arc(x + r, y + r, r, Math.PI, 1.5 * Math.PI);
  ctx.closePath();
}

export const FrameDrawing = () => {
  return (
    <drawingarea
      hexpand
      vexpand
      canTarget={false}
      canFocus={false}
      sensitive={false}
      $={(da: Gtk.DrawingArea) => {
        da.set_draw_func(
          (_area: Gtk.DrawingArea, ctx: CairoContext, w: number, h: number) => {
            const { r, g, b, a } = BG_COLOR;

            // Calculate hole geometry
            const x = EDGE_WIDTH;
            const y = BAR_HEIGHT;
            const iw = Math.max(0, w - EDGE_WIDTH * 2);
            const ih = Math.max(0, h - BAR_HEIGHT * 2);

            // Fix pixelated weirdness
            ctx.setAntialias(Cairo.Antialias.BEST);

            // Draw frame background (rounded outer corners)
            ctx.setOperator(Cairo.Operator.OVER);
            ctx.setSourceRGBA(r, g, b, a);
            // roundedRect(ctx, 0, 0, w, h, BORDER_RADIUS);
            ctx.rectangle(0, 0, w, h);
            ctx.fill();

            // Cut out the middle (transparent center with rounded corners)
            ctx.setOperator(Cairo.Operator.CLEAR);
            roundedRect(ctx, x, y, iw, ih, BORDER_RADIUS);
            ctx.fill();

            // Set input region to exclude the cutout
            // Use get_native()?.get_surface() like OkPanel does
            const surf = shellWindow?.get_native()?.get_surface();
            if (!surf) return;

            const winW = shellWindow.get_allocated_width();
            const winH = shellWindow.get_allocated_height();

            // Compute offset of drawing area inside the window
            const boundsResult = da.compute_bounds(shellWindow);
            const bounds = boundsResult[1];
            const daOffX = bounds ? bounds.get_x() : 0;
            const daOffY = bounds ? bounds.get_y() : 0;

            // Hole rect in *window* coords
            const holeL = Math.max(0, Math.floor(daOffX + x));
            const holeT = Math.max(0, Math.floor(daOffY + y));
            const holeR = Math.min(winW, Math.ceil(daOffX + x + iw));
            const holeB = Math.min(winH, Math.ceil(daOffY + y + ih));

            const region = new Cairo.Region();

            const addRect = (X: number, Y: number, W: number, H: number) => {
              if (W <= 0 || H <= 0) return;
              // @ts-expect-error - Missing from types
              region.unionRectangle(
                new Cairo.RectangleInt({ x: X, y: Y, width: W, height: H }),
              );
            };

            // Four bands around the hole (all in window coords)
            // Top
            addRect(0, 0, winW, holeT);
            // Left
            addRect(0, holeT, holeL, Math.max(0, holeB - holeT));
            // Right
            addRect(
              holeR,
              holeT,
              Math.max(0, winW - holeR),
              Math.max(0, holeB - holeT),
            );
            // Bottom
            addRect(0, holeB, winW, Math.max(0, winH - holeB));

            surf.set_input_region(region);
          },
        );
      }}
    />
  );
};

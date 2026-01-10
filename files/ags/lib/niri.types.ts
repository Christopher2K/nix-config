export type NiriEventHandler = (event: NiriEvent) => void;

export interface NiriEvent {
  name: string;
  value: unknown;
}

export interface NiriFocusedWindow {
  id: number;
  title: string;
  app_id: string;
  pid: number;
  workspace_id: number;
  is_focused: boolean;
  is_floating: boolean;
  is_urgent: boolean;
  layout: {
    pos_in_scrolling_layout: [number, number];
    tile_size: [number, number];
    window_size: [number, number];
    tile_pos_in_workspace_view: [number, number] | null;
    window_offset_in_tile: [number, number];
  };
  focus_timestamp: {
    secs: number;
    nanos: number;
  };
}

export interface NiriSubscription {
  stop(): void;
}

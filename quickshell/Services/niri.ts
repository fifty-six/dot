type NiriEvent =
    { WorkspacesChanged: WorkspacesChanged }
  | { WindowsChanged: WindowsChanged }
  | { KeyboardLayoutsChanged: KeyboardLayoutsChanged }
  | { OverviewOpenedOrClosed: OverviewOpenedOrClosed }
  | { ConfigLoaded: ConfigLoaded }
  | { WorkspaceActivated: WorkspaceActivated }
  | { WindowOpenedOrChanged: WindowOpenedOrChanged }
  | { WindowFocusChanged: WindowFocusChanged };

interface WorkspacesChanged {
  workspaces: Workspace[]
}

interface Workspace {
  id: number
  idx: number
  name?: string
  output: string
  is_urgent: boolean
  is_active: boolean
  is_focused: boolean
  active_window_id?: number
}


interface WindowsChanged {
  windows: Window[]
}

interface WindowFocusChanged {
    id: Id;
}

interface Window {
  id: number
  title: string
  app_id: string
  pid: number
  workspace_id: number
  is_focused: boolean
  is_floating: boolean
  is_urgent: boolean
  layout: Layout
}

interface Layout {
  pos_in_scrolling_layout: number[]
  tile_size: number[]
  window_size: number[]
  tile_pos_in_workspace_view: any
  window_offset_in_tile: number[]
}

interface KeyboardLayoutsChanged {
  keyboard_layouts: KeyboardLayouts
}

interface KeyboardLayouts {
  names: string[]
  current_idx: number
}

interface OverviewOpenedOrClosed {
  is_open: boolean
}

interface ConfigLoaded {
  failed: boolean
}

type Id = number;

interface NiriService {
    windows: Map<Id, Window>;

    workspaces: Map<Id, Workspace>;

    active_idx: number
    // TODO: remove this qml side
    workspace_cnt: number

    title: string;
}

interface WindowOpenedOrChanged {
  window: Window
}

// {"WorkspaceActivated":{"id":2,"focused":true}}
interface WorkspaceActivated {
    id: Id,
    focused: boolean
}

const workspaceChanged = (ev: WorkspacesChanged, ns: NiriService) => {
    let { workspaces } = ev;

    ns.workspaces = new Map()

    for (let [idx, ws] of workspaces.entries()) {
        ns.workspaces.set(ws.id, ws);

        if (ws.is_focused) {
            ns.active_idx = idx + 1;
        }
    }

    ns.workspace_cnt = workspaces.length;
}

function windows_changed(wc: WindowsChanged, ns: NiriService) {
    ns.windows = new Map();
    // The map constructor doesn't work in QML because idk
    for (let window of wc.windows) {
        ns.windows.set(window.id, window);
    }

    let focused = wc.windows.find(x => x.is_focused);

    if (focused !== undefined) {
        ns.title = focused.title;
    }
}

export const handleEvent = (evRaw: string, ns: NiriService) => {
    let ev: NiriEvent = JSON.parse(evRaw);

    if ('WorkspacesChanged' in ev) {
        workspaceChanged(ev.WorkspacesChanged, ns);
    } else if ('WorkspaceActivated' in ev) {
        ns.active_idx = ns.workspaces.get(ev.WorkspaceActivated.id)!.idx - 1;
    } else if ('WindowOpenedOrChanged' in ev) {
        let { window } = ev.WindowOpenedOrChanged;

        ns.windows.set(window.id, window);

        if (window.is_focused) {
            ns.title = window.title;
        }
    } else if ('WindowsChanged' in ev) {
        windows_changed(ev.WindowsChanged, ns);
    } else if ('WindowFocusChanged' in ev) {
        ns.title = ns.windows.get(ev.WindowFocusChanged.id)?.title ?? ns.title;
    }
    // need to handle: focus event, references old state so we need to store that too.
};


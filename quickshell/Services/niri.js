const workspaceChanged = (ev, ns) => {
    let { workspaces } = ev;
    for (let [idx, ws] of workspaces.entries()) {
        if (ws.is_focused) {
            ns.active_idx = idx + 1;
        }
    }
    ns.workspace_cnt = workspaces.length;
};
function windows_changed(wc, ns) {
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
export const handleEvent = (evRaw, ns) => {
    let ev = JSON.parse(evRaw);
    // console.debug(`dbg: ${JSON.stringify(ns.windows)}`);
    if ('WorkspacesChanged' in ev) {
        workspaceChanged(ev.WorkspacesChanged, ns);
    }
    else if ('WorkspaceActivated' in ev) {
        ns.active_idx = ev.WorkspaceActivated.id - 1;
    }
    else if ('WindowOpenedOrChanged' in ev) {
        let { window } = ev.WindowOpenedOrChanged;
        ns.windows.set(window.id, window);
        if (window.is_focused) {
            ns.title = window.title;
        }
    }
    else if ('WindowsChanged' in ev) {
        windows_changed(ev.WindowsChanged, ns);
    }
    else if ('WindowFocusChanged' in ev) {
        ns.title = ns.windows.get(ev.WindowFocusChanged.id)?.title ?? ns.title;
    }
    // need to handle: focus event, references old state so we need to store that too.
};

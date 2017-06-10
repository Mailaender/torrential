/*
* Copyright (c) 2017 David Hewitt (https://github.com/davidmhewitt)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: David Hewitt <davidmhewitt@gmail.com>
*/

public class Torrential.MainWindow : Gtk.Window {
    private Torrential.Application app;

    private Gtk.Menu app_menu = new Gtk.Menu();
    private Gtk.MenuItem preferences_item;
    private Gtk.MenuItem about_item;

    private SimpleActionGroup actions = new SimpleActionGroup ();

    private const string ACTION_GROUP_PREFIX_NAME = "tor";
    private static string ACTION_GROUP_PREFIX = ACTION_GROUP_PREFIX_NAME + ".";

    private const string ACTION_PREFERENCES = "undo";
    private const string ACTION_ABOUT = "redo";
    private const string ACTION_QUIT = "quit";
    private const string ACTION_OPEN = "open";

    private const ActionEntry[] action_entries = {
        {ACTION_PREFERENCES,                on_preferences          },
        {ACTION_ABOUT,                      on_about                },
        {ACTION_QUIT,                       on_quit                 },
        {ACTION_OPEN,                       on_open                 }
    };

    private static Gee.MultiMap<string, string> action_accelerators = new Gee.HashMultiMap<string, string> ();
    static construct {
        action_accelerators.set (ACTION_PREFERENCES, "<Ctrl>comma");
        action_accelerators.set (ACTION_QUIT, "<Ctrl>q");
        action_accelerators.set (ACTION_OPEN, "<Ctrl>o");
    }

    public MainWindow (Torrential.Application app) {
        this.app = app;

        actions.add_action_entries (action_entries, this);
        insert_action_group (ACTION_GROUP_PREFIX_NAME, actions);
        foreach (var action in action_accelerators.get_keys ()) {
            app.set_accels_for_action (ACTION_GROUP_PREFIX + action,
                                       action_accelerators[action].to_array ());
        }

        var headerbar = new Gtk.HeaderBar ();
        headerbar.show_close_button = true;

        var about_button = new Gtk.MenuButton ();
        about_button.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
        about_button.tooltip_text = _("Application menu");
        about_button.popup = build_menu ();
        headerbar.pack_end (about_button);

        var open_button = new Gtk.ToolButton.from_stock (Gtk.Stock.OPEN);
        headerbar.pack_start (open_button);

        var all_category = new Granite.Widgets.SourceList.Item (_("All"));
        all_category.icon = Icon.new_for_string ("folder");
        all_category.badge = "0";
        var downloading_category = new Granite.Widgets.SourceList.Item (_("Downloading"));
        downloading_category.icon = Icon.new_for_string ("go-down");
        downloading_category.badge = "0";
        var seeding_category = new Granite.Widgets.SourceList.Item (_("Seeding"));        
        seeding_category.icon = Icon.new_for_string ("go-up");
        seeding_category.badge = "0";
        var paused_category = new Granite.Widgets.SourceList.Item (_("Paused"));
        paused_category.icon = Icon.new_for_string ("media-playback-pause");
        paused_category.badge = "0";
        var search_category = new Granite.Widgets.SourceList.Item (_("Search Results"));
        search_category.icon = Icon.new_for_string ("edit-find");
        search_category.badge = "0";

        var sidebar = new Granite.Widgets.SourceList ();
        var root = sidebar.root;
        root.add (all_category);
        root.add (downloading_category);
        root.add (seeding_category);
        root.add (paused_category);
        root.add (search_category);
    
        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        pane.position = 175;
		this.add (pane);

		pane.add1 (sidebar);
		pane.add2 (new Gtk.Label ("Right"));

        set_default_size (900, 600);
        set_titlebar (headerbar);
        show_all ();
    }

    private Gtk.Menu build_menu () {
        preferences_item = new Gtk.MenuItem.with_mnemonic (_("_Preferences"));
        preferences_item.set_action_name (ACTION_GROUP_PREFIX + ACTION_PREFERENCES);
        app_menu.append (preferences_item);

        about_item = new Gtk.MenuItem.with_mnemonic (_("_About"));
        about_item.set_action_name (ACTION_GROUP_PREFIX + ACTION_ABOUT);
        app_menu.append (about_item);

        app_menu.show_all ();

        return app_menu;
    }

    private void on_preferences (SimpleAction action) {
        var prefs_window = new PreferencesWindow (this);
        prefs_window.show_all ();
    }

    private void on_about (SimpleAction action) {
        app.show_about (this);
    }

    private void on_quit (SimpleAction action) {
        close ();
    }

    private void on_open (SimpleAction action) {
    }
}
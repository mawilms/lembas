use iced::{Element, Sandbox, Settings, Text};

pub struct MainWindow;

impl Sandbox for MainWindow {
    type Message = ();

    fn new() -> MainWindow {
        MainWindow
    }

    fn title(&self) -> String {
        String::from("Lembas")
    }

    fn update(&mut self, _message: Self::Message) {
        // This application has no interactions
    }

    fn view(&mut self) -> Element<Self::Message> {
        Text::new("Hello, world!").into()
    }
}

impl MainWindow {
    pub fn start() {
        let mut settings: Settings<()> = Settings::default();
        settings.window.size = (800, 420);
        MainWindow::run(settings).unwrap_err();
    }
}

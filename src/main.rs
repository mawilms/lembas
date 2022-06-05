use env_logger::Env;
use lembas::gui::views::Lembas;

fn main() {
    let env = Env::default().filter_or("RUST_LOG", "lembas=debug");
    env_logger::init_from_env(env);

    Lembas::start();
}

/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./src/**/*.{svelte,html,js}"],
    theme: {
        extend: {},
        colors: {
            "black": "#000000",
            "primary": "#9FC200",
            "primary-transparent": "rgba(159,194,0,0.2)",
            "light-brown": "#371f19",
            "dark-brown": "rgb(36, 21, 18)"
        }
    },
    plugins: [],
}

// daisyui: {
//     themes: [
//         {
//             mytheme: {
//                 "primary": "#9FC200",
//                 "secondary": "#0000ff",
//                 "accent": "#00f5ff",
//                 "neutral": "#161616",
//                 "base-100": "#1B2636",
//                 "info": "#00a9f5",
//                 "success": "#75c600",
//                 "warning": "#f9a300",
//                 "error": "#ff5583",
//             },
//         },
//         {
//             hobbit: {
//                 "primary": "#4d7e00",
//                 "secondary": "#0081ff",
//                 "accent": "#32d100",
//                 "neutral": "#141200",
//                 "base-100": "#371f19",
//                 "info": "#00d8ff",
//                 "success": "#4d7e00",
//                 "warning": "#bf3d00",
//                 "error": "#ff1748",
//             }
//         }
//     ],
// },
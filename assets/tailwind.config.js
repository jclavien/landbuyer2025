// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/landbuyer2025_web.ex",
    "../lib/landbuyer2025_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        bg1: 'rgb(30 41 59)',       // slate-800
        bg2: 'rgb(51 65 85)',       // slate-700
        bg3: 'rgb(71 85 105)',      // slate-600
        text: 'rgb(226 232 240)',   // slate-200
        primary: 'rgb(14 165 233)', // sky-500
        secondary: 'rgb(125 211 252)', // sky-300
        green: 'rgb(22 163 74)',    // green-600
        red: 'rgb(220 38 38)',      // red-600
      },
      fontFamily: {
        sans: ['Segoe UI', 'sans-serif'],
      },
      borderRadius: {
        DEFAULT: '0.25rem', // rounded
      },
      safelist: [
        {
          pattern: /text-(slate|sky|blue|green|red|gray|amber|yellow|purple|pink|indigo)-[0-9]{3}/
        },
        {
          pattern: /bg-(slate|sky|blue|green|red|gray|amber|yellow|purple|pink|indigo)-[0-9]{3}/
        }
      ],
      
    },

  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ]
}

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "suggestions"]

    connect() {
        console.log("Search controller connected")
        // The suggestions target is now in the HTML, no need to create it
    }

    input(event) {
        const query = event.target.value.trim()
        console.log("Search input:", query)

        if (query.length < 2) {
            this.hideSuggestions()
            return
        }

        // Dummy data for suggestions
        const dummyData = [
            "In a Dry Season",
            "In a Dark Wood",
            "In a Different Light",
            "In a Different Place",
            "Fair Stood the Wind for France"
        ]

        // Filter suggestions based on query
        const filteredSuggestions = dummyData.filter(item =>
            item.toLowerCase().includes(query.toLowerCase())
        )

        console.log("Filtered suggestions:", filteredSuggestions)
        this.showSuggestions(filteredSuggestions)
    }

    showSuggestions(suggestions) {
        const suggestionsTarget = this.suggestionsTarget
        suggestionsTarget.innerHTML = ""

        if (suggestions.length === 0) {
            this.hideSuggestions()
            return
        }

        suggestions.forEach(suggestion => {
            const div = document.createElement("div")
            div.classList.add("suggestion-item")
            div.textContent = suggestion
            div.addEventListener("click", () => this.selectSuggestion(suggestion))
            suggestionsTarget.appendChild(div)
        })

        suggestionsTarget.style.display = "block"
    }

    hideSuggestions() {
        this.suggestionsTarget.style.display = "none"
    }

    selectSuggestion(suggestion) {
        this.inputTarget.value = suggestion
        this.hideSuggestions()
    }
}
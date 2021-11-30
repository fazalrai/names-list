import React from 'react'
import ReactDOM from 'react-dom'

import axios from 'axios'

import Names from './Names'
import Name from './Name'
import NameForm from './NameForm'
import Spinner from './Spinner'
import ErrorMessage from './ErrorMessage'
class NamesApp extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            searchText: "",
            names: [],
            hideCompletedNames: false,
            isLoading: true,
            errorMessage: null,
        }
        this.getNames = this.getNames.bind(this)
        this.createTodoItem = this.createTodoItem.bind(this)
        this.toggleCompletedNames = this.toggleCompletedNames.bind(this)
        this.handleErrors = this.handleErrors.bind(this)
        this.clearErrors = this.clearErrors.bind(this)
        this.handleSearchText = this.handleSearchText.bind(this)
    }
    componentDidMount() {
        this.getNames()
    }
    getNames() {
        let keywords = this.state.searchText ? `&keywords=${this.state.searchText}` : ''
        axios
            .get(`/api/v1/names?${keywords}`)
            .then(response => {
                this.clearErrors()
                this.setState({ isLoading: true })
                const names = response.data
                this.setState({ names })
                this.setState({ isLoading: false })
            })
            .catch(error => {
                this.setState({ isLoading: true })
                this.setState({
                    errorMessage: {
                        message:
                            'There was an error loading your todo items...',
                    },
                })
            })
    }
    createTodoItem(name) {
        const names = [name, ...this.state.names]
        this.setState({ names })
    }
    toggleCompletedNames() {
        this.setState({
            hideCompletedNames: !this.state.hideCompletedNames,
        })
    }
    handleErrors(errorMessage) {
        this.setState({ errorMessage })
    }
    clearErrors() {
        this.setState({
            errorMessage: null,
        })
    }

    handleSearchText(event){
        let keywords = event.target.value
        this.setState({searchText: keywords})

        clearTimeout(this.inputTimer);
        this.inputTimer = setTimeout(() => {
          this.getNames();
        }, 1000);
    };

    render() {
        return (
            <>
                <div className="form-row">
                    <div className="form-group col-md-12">
                        <input
                            type="text"
                            name="title"
                            value={this.state.searchText}
                            className="form-control"
                            id="title"
                            placeholder="Search"
                            onChange={e => this.handleSearchText(e)}
                        />
                    </div>
                </div>
                {this.state.errorMessage && (
                    <ErrorMessage errorMessage={this.state.errorMessage} />
                )}
                {!this.state.isLoading && (
                    <>
                        <NameForm
                            createTodoItem={this.createTodoItem}
                            handleErrors={this.handleErrors}
                            clearErrors={this.clearErrors}
                        />
                        <Names
                            toggleCompletedNames={
                                this.toggleCompletedNames
                            }
                            hideCompletedNames={
                                this.state.hideCompletedNames
                            }
                        >
                            {this.state.names.map(name => (
                                <Name
                                    key={name.id}
                                    name={name}
                                    getNames={this.getNames}
                                    hideCompletedNames={
                                        this.state.hideCompletedNames
                                    }
                                    handleErrors={this.handleErrors}
                                    clearErrors={this.clearErrors}
                                />
                            ))}
                        </Names>
                    </>
                )}
                {this.state.isLoading && <Spinner />}
            </>
        )
    }
}

document.addEventListener('turbolinks:load', () => {
    const app = document.getElementById('names-app')
    app && ReactDOM.render(<NamesApp />, app)
})

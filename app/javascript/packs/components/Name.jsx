import React from 'react'
import PropTypes from 'prop-types'

import _ from 'lodash'
import axios from 'axios'
import setAxiosHeaders from './AxiosHeaders'
class Name extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            complete: this.props.name.complete,
        }
        this.handleDestroy = this.handleDestroy.bind(this)
        this.handleChange = this.handleChange.bind(this)
        this.updateTodoItem = this.updateTodoItem.bind(this)
        this.inputRef = React.createRef()
        this.completedRef = React.createRef()
        this.path = `/api/v1/names/${this.props.name.id}`
    }
    handleChange() {
        this.setState({
            complete: this.completedRef.current.checked,
        })
        this.updateTodoItem()
    }
    updateTodoItem = _.debounce(() => {
        setAxiosHeaders()
        axios
            .put(this.path, {
                todo_item: {
                    title: this.inputRef.current.value,
                    complete: this.completedRef.current.checked,
                },
            })
            .then(() => {
                this.props.clearErrors()
            })
            .catch(error => {
                this.props.handleErrors(error)
            })
    }, 1000)
    handleDestroy() {
        setAxiosHeaders()
        const confirmation = confirm('Are you sure?')
        if (confirmation) {
            axios
                .delete(this.path)
                .then(response => {
                    this.props.getNames()
                })
                .catch(error => {
                    console.log(error)
                })
        }
    }
    render() {
        const { name } = this.props
        return (
            <tr
                className='table-light'
            >
                <td>
                    <p>{name.title}</p>
                </td>
                <td className="text-right">
                    <button
                        onClick={this.handleDestroy}
                        className="btn btn-outline-danger"
                    >
                        Delete
                    </button>
                </td>
            </tr>
        )
    }
}

export default Name

Name.propTypes = {
    name: PropTypes.object.isRequired,
    getNames: PropTypes.func.isRequired,
    hideCompletedNames: PropTypes.bool.isRequired,
    clearErrors: PropTypes.func.isRequired,
}

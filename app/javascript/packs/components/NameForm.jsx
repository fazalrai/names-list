import React from 'react'
import PropTypes from 'prop-types'

import axios from 'axios'
import setAxiosHeaders from './AxiosHeaders'
class NameForm extends React.Component {
    constructor(props) {
        super(props)
        this.handleSubmit = this.handleSubmit.bind(this)
        this.titleRef = React.createRef()
    }

    handleSubmit(e) {
        e.preventDefault()
        setAxiosHeaders()
        axios.post('/api/v1/names', {               
                    title: this.titleRef.current.value               
            })
            .then(response => {
                const name = response.data
                this.props.createName(name)
                this.props.clearErrors()
            })
            .catch(error => {
                this.props.handleErrors(error)
            })
        e.target.reset()
    }

    render() {
        return (
            <form onSubmit={this.handleSubmit} className="my-3">
                <div className="form-row">
                    <div className="form-group col-md-8">
                        <input
                            type="text"
                            name="title"
                            ref={this.titleRef}
                            required
                            className="form-control"
                            id="title"
                            placeholder="Write your name here..."
                        />
                    </div>
                    <div className="form-group col-md-4">
                        <button className="btn btn-outline-success btn-block">
                            Add Name
                        </button>
                    </div>
                </div>
            </form>
        )
    }
}

export default NameForm

NameForm.propTypes = {
    createName: PropTypes.func.isRequired,
    handleErrors: PropTypes.func.isRequired,
    clearErrors: PropTypes.func.isRequired,
}

import React from 'react'
import PropTypes from 'prop-types'

import _ from 'lodash'
import axios from 'axios'
import setAxiosHeaders from './AxiosHeaders'
class Name extends React.Component {
    constructor(props) {
        super(props)
    }

    render() {
        const { name } = this.props
        return (
            <tr className="table-light">
                <td>
                    <p>{name.title}</p>
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

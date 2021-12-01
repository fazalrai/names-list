import React from 'react'
import PropTypes from 'prop-types'

class Names extends React.Component {
    constructor(props) {
        super(props)
        this.handleClick = this.handleClick.bind(this)
    }
    handleClick() {
        this.props.toggleCompletedNames()
    }

    render() {
        return (
            <>
                <hr />
                <div className="table-responsive">
                    <table className="table">
                        <thead>
                            <tr>
                                <th scope="col">Name</th>
                            </tr>
                        </thead>
                        <tbody>{this.props.children}</tbody>
                    </table>
                </div>
            </>
        )
    }
}
export default Names

Names.propTypes = {
    toggleCompletedNames: PropTypes.func.isRequired,
    hideCompletedNames: PropTypes.bool.isRequired,
}

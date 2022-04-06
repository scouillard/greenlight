import React from 'react';
import { Card, Row, Col } from 'react-bootstrap';
import ButtonLink from '../stylings/buttons/ButtonLink';
import SignupForm from '../forms/SignupForm';
import FormLogo from '../forms/FormLogo';
import { Link } from 'react-router-dom';

export default function Signup() {
  return (
    <>
      <FormLogo />
      <Card className="col-md-4 mx-auto p-4 border-0 shadow-sm user-forms">
        <Card.Title className="text-center pb-2"> Create an Account </Card.Title>
          <SignupForm />
        <span className="text-center text-muted small"> Already have an account?
         <Link to="/signin" className="text-link"> Sign In </Link>
        </span>
      </Card>
    </>
  );
}

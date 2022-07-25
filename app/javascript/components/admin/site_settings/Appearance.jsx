import React, { useState } from 'react';
import { Row } from 'react-bootstrap';
import { TwitterPicker } from 'react-color';
import useUpdateSiteSetting
  from '../../../hooks/mutations/admins/site_settings/useUpdateSiteSetting';

export default function Appearance() {
  // const [colorz, setColor] = useState('#FFF');
  const updateSiteSetting = useUpdateSiteSetting('PrimaryColor');

  // const handleChangeComplete = (color) => {
  //   setColor(color?.hex);
  //   console.log(color?.hex);
  // };

  // const handleSetColor = (color) => {
  //   document.documentElement.style.setProperty('--brand', color);
  // }

  return (
    <>

      <br/>
      <br/>
      <br/>

      {/* <Row> */}
      {/*   <h6> Primary Color </h6> */}
      {/*   <p> {colorz} </p> */}
      {/*   <p className={colorz}>Changing the regular color will change both Lighten and Darken.</p> */}
      {/*   <input */}
      {/*     type="color" */}
      {/*     className="form-control form-control-color" */}
      {/*     id="exampleColorInput" */}
      {/*     // value="#563d7c" */}
      {/*     title="Choose your color" */}
      {/*     onBlur={(event) => console.log(event.target.value)} */}
      {/*   /> */}

      {/* </Row> */}

      <br/>
        <br/>
          <br/>

      {/* <Row> */}
      {/*   <h6> Primary Color </h6> */}
      {/*   <p className="text-muted">Changing the regular color will change both Lighten and Darken.</p> */}
      {/*   <TwitterPicker */}
      {/*     color={colorz} */}
      {/*     onChangeComplete={handleChangeComplete} */}
      {/*     width="300px" */}
      {/*     triangle="hide" */}
      {/*   /> */}
      {/* </Row> */}

      <Row>
        <button type="button" variant="brand" onClick={() => updateSiteSetting.mutate({ value: '#1A454A' })}>click me</button>
        <button type="button" variant="brand" onClick={() => updateSiteSetting.mutate({ value: 'red' })}>click me</button>
        <button type="button" variant="brand" onClick={() => updateSiteSetting.mutate({ value: 'green' })}>click me</button>
      </Row>
    </>

  );
}
